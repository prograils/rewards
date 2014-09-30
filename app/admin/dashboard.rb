ActiveAdmin.register_page 'Dashboard' do

  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }
  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Active users' do
          table_for User.active do
            column 'First name', :first_name
            column 'Last name', :last_name
            column 'Money received in this month', :received_sum
            column 'Money given in this month', :spent_sum
          end
        end
      end
    end
  end
end
