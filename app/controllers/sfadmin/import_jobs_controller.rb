module Sfadmin
  class ImportJobsController < Sfadmin::AdminController
    
    before_action :load_import_job, only: [ :show, :destroy ]
    
    def index
    	@import_jobs = current_admin.import_jobs.order('created_at DESC')
      
      respond_to do |format|
        format.json { render json: @import_jobs }
        format.html
      end
    end

    def new
    	@import_job = ImportJob.new
    end

    def create
    	@import_job = current_admin.import_jobs.build import_job_params
    	if @import_job.save
    		redirect_to [ :sfadmin, @import_job ]
    	else
    		render :new
    	end
    end

    def show
      render partial: 'log' if request.xhr?
    end

    def destroy
      @import_job.delete_job!
      redirect_to [ :sfadmin, @import_job ]
    end
    
    private
    
    def import_job_params
      params.require(:import_job).permit(:url)
    end
    
    def load_import_job
      @import_job = current_admin.import_jobs.find_by id: params[:id]
    end
    
  end
end
