module AresMUSH
  module Login
    class EmailViewCmd
      include CommandHandler
      include CommandRequiresLogin

      attr_accessor :name

      def crack!
        self.name = !cmd.args ? enactor_name : trim_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |char|
          
          if !Login.can_access_email?(enactor, char)
            client.emit_failure t('dispatcher.not_allowed') 
            return
          end
          
          if (!char.login_prefs || !char.login_prefs.email)
            client.emit_ooc(t('login.no_email_is_registered', :name => char.name))
          else
            client.emit_ooc(t('login.email_registered_is', :name => char.name, 
                :email => char.login_prefs.email))
          end
        end
      end
    end
  end
end
