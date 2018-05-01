class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, except: [:service_worker]
  before_action :authenticate_activated_user!, except: [:heartbeat, :home, :service_worker, :geoname_summaries, :tags, :privacy, :data_policy]
  # before_action :authenticate_qkunst_user!, except: [:heartbeat, :home]
  before_action :offline?
  before_action :show_hidden
  before_action :set_time_zone

  def home

  end

  def privacy

  end

  def geoname_summaries
    response.headers["Cache-Control"] = "public"
    response.headers["Pragma"] = "cache"
    response.headers["Expires"] = (Time.now+1.week).rfc822

    render json: GeonameSummary.selectable.to_array.to_json
  end

  def tags
    response.headers["Cache-Control"] = "public"
    response.headers["Pragma"] = "cache"

    return_tags = ActsAsTaggableOn::Tag.all.where(ActsAsTaggableOn::Tag.arel_table[:name].matches("#{params[:q]}%")).collect{|a| {id: a.name, text: a.name}}
    return_tags += [{id: params[:q], text: "Nieuwe tag: #{params[:q]}"}]

    render json: {results: return_tags}
  end

  def offline?
    @offline = params[:offline]
  end

  def debug_offline
    @offline = true
  end

  def admin

  end

  def data_policy

  end

  def service_worker

  end


  def heartbeat
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    render plain: 'alive', layout: false
  end

  def admin_user?
    current_user && current_user.admin?
  end

  def qkunst_user?
    current_user && current_user.qkunst?
  end

  private

  def show_hidden
    @show_hidden = false
    if params[:show_hidden] && (params[:show_hidden] == "true" or params[:show_hidden] == true)
      @show_hidden = true
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_collection
    authenticate_activated_user!
    if params[:collection_id]
      # @collection = Collection.find(params[:collection_id])
      begin
        @collection = current_user.accessible_collections.find(params[:collection_id])
      rescue
        redirect_to root_path, {alert: "U heeft geen toegang tot deze collectie"}
      end
    elsif @work
      @collection = @work.collection
    end
    if @collection
      unless current_user.admin?
        redirect_options = offline? ? {} : {alert: "U heeft geen toegang tot deze collectie"}
        redirect_to root_path, redirect_options unless @collection.can_be_accessed_by_user(current_user)
      end
    end
  end

  def set_work
    authenticate_activated_user!
    if params[:work_id]
      begin
        @work = current_user.accessible_works.find(params[:work_id])
      rescue
        redirect_to root_path, alert: "U heeft geen toegang tot dit werk." unless @work.collection == @collection
      end
    end
  end

  def authenticate_qkunst_user!
    unless devise_controller?
      authenticate_user!
      if current_user
        redirect_options = offline? ? {} : {alert: "Alleen medewerkers van QKunst kunnen deze pagina bekijken"}
        redirect_to root_path, redirect_options unless current_user.qkunst?
      end
    end
  end

  def authenticate_qkunst_user_if_no_collection!
    set_collection
    unless current_user.qkunst? or @collection
      redirect_options = offline? ? {} : {alert: "U dient een QKunst medewerker te zijn"}
      redirect_to root_path, redirect_options
    end
  end

  def authenticate_qkunst_or_facility_user!
    authenticate_user!
    if current_user
      redirect_options = offline? ? {} : {alert: "U heeft geen toegang tot deze pagina"}
      redirect_to root_path, redirect_options unless (current_user.qkunst? or current_user.facility_manager?)
    end
  end

  def authenticate_admin_or_facility_user!
    authenticate_user!
    if current_user
      redirect_options = offline? ? {} : {alert: "U heeft geen toegang tot deze pagina"}
      redirect_to root_path, redirect_options unless (current_user.admin? or current_user.facility_manager?)
    end
  end

  def authenticate_activated_user!
    return true if controller_name == "offline"

    unless devise_controller?
      authenticate_user!
      if current_user
        redirect_options = offline? ? {} : {alert: "Alleen geactiveerde gebruikers kunnen deze pagina bekijken. Nog niet geactiveerd? Neem contact op met QKunst."}
        redirect_to root_path, redirect_options unless current_user.activated?
      end
    end
  end

  def authenticate_admin_user!
    authenticate_user!
    if current_user
      redirect_options = offline? ? {} : {alert: "Alleen administratoren van QKunst kunnen deze pagina bekijken"}
      redirect_to root_path, redirect_options unless current_user.admin?
    end
  end

  def set_time_zone
    Time.zone = 'Amsterdam'
  end

  rescue_from CanCan::AccessDenied do
    if current_user
      redirect_to root_path, :alert => "Je hebt geen toegang tot deze pagina"
    else
      redirect_to new_user_session_url(redirect_to: request.url), alert: "Je moet ingelogd zijn om deze pagina te kunnen bekijken."
      # raise exception
    end
  end

end
