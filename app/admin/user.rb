ActiveAdmin.register User do
  action_item only: :index do
    link_to "Change default limit from #{Setting.default_limit}", set_default_limit_admin_users_path
  end

  index do
    selectable_column
    column :id
    column :email, sortable: :email do |user|
      link_to user.email, admin_user_path(user)
    end
    column :first_name
    column :last_name
    column :is_active do |user|
      link_to user.is_active?.to_s, [:activate, :admin, user]
    end
    column :limit
    column :received_sum
    column :spent_sum
  end

  show do |user|
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :is_active do
        link_to user.is_active?.to_s, [:activate, :admin, user]
      end
      row :limit
      row :received_sum
      row :spent_sum
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :is_active
      f.input :limit
      f.input :password if f.object.new_record?
    end
    f.actions
  end

  collection_action :set_default_limit, method: :get do
    render 'admin/set_default_limit'
  end

  member_action :activate, method: :get do
    @user = User.find(params[:id])
    @user.is_active = true
    @user.save
    redirect_to :back
  end

  batch_action :change_limit do |selection|
    @users = User.where(id: selection)
    if @users.blank?
      redirect_to :back
    else
      render template: 'admin/edit_users'
    end
  end

  controller do

    def create
      @user = User.new(permitted_params[:user])
      if @user.save
        @user.confirm!
        redirect_to [:admin, @user]
      else
        logger.info @user.errors.map { |k, e| [k, e] }
        render action: :new
      end
    end

    def permitted_params
      params.permit user: [:email, :password, :first_name, :last_name, :is_active, :limit]
    end
  end
end
