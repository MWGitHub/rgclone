class Api::SourceFilesController < ApplicationController
  before_filter :require_signed_in!, only: [:create, :update, :destroy]

  def show
    @source_file = SourceFile.find(params[:id])
  end

  def create
    @project = Project.find(params[:project_id])
    input = {author_id: @project.author_id}.merge(source_file_params)
    @source_file = project.create!(input)
    if @source_file && source_file_params[:body]
      input = {author_id: @project.author_id}.merge(source_file_params)
      @source_file.text_changes.create!(input)
    end
    render :show
  end

  def update
    @source_file = SourceFile.find(params[:id])
    @source_file.slug = nil
    @source_file.update!(source_file_params)
    if @source_file && source_file_params[:body]
      @source_file.text_changes.create!(source_file_params[:body])
    end
    render :show
  end

  def destroy
    @source_file = SourceFile.find(params[:id])
    @source_file.destroy
    render :show
  end

  private
  def source_file_params
    params.require(:source_file).permit(:title, :body)
  end
end
