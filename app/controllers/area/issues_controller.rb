class Area::IssuesController < Area::BaseController
  before_filter :load_issue,
    :only => :show
  
  def index
    if params[:year].present? and params[:month].present?
      @current_month = Time.parse([params[:year], params[:month], '01'].join('-')).to_date
    else
      @current_month = Date.today.beginning_of_month
    end
    @issues = @area.issues.sent.in_month(@current_month.strftime("%Y-%m")).order('sent_at DESC')
  end

  def show
    @prev_issue = @area.issues.find_by_number(@issue.number-1)
    @next_issue  = @area.issues.find_by_number(@issue.number+1)
  end
  
  def current
    @issue = @area.issues.sent.last
    if @issue.present?
      render :template => 'area/issues/show'
    else
      render :text => 'Issue not found', :status => 404
    end
  end

protected
  def load_issue
    @issue = @area.issues.sent.find_by_number!(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'Issue not found', :status => 404
  end
  
end
