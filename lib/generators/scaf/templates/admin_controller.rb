class Admin::<%= plural_class_name %>Controller < Admin::AdminController

  load_and_authorize_resource

  def index
    @<%= item %> = <%= class_name %>.new
  end

  def new; end
  def edit; end

  def create
    @<%= item %> = <%= class_name %>.new params[:<%= item %>]
    @<%= item %>.save!
    respond_to do |format|
      format.html { redirect_to <%= admin_index_path %>, notice: (flash.now.notice = translate_notice) }
      format.js { @elemento = @<%= item %> }
    end
  end

  def update
    @<%= item %>.update_attributes! params[:<%= item %>]
    redirect_to <%= admin_edit_path %>(@<%= item %>), notice: translate_notice
  end

  def destroy
    @id = @<%= item %>.id
    @<%= item %>.eliminar!

    respond_to do |format|
      format.html { redirect_to <%= admin_items_path %>, notice: (flash.now.notice = translate_notice) }
      format.js
    end
  end
  
  private

  def translate_notice
    t("notice.#{action_name}", :elemento => @<%= item %>)
  end
end
