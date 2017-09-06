class FieldsController < ApplicationController
  before_action :set_field, only: [:show, :edit, :update, :destroy]

  def index
    @fields = Field.all
    gon.field_shapes = @fields.map(&:geo_json_with_props)
  end

  def show
    gon.field_shape = @field.geo_json_with_props
  end

  def new
    @field = Field.new
  end

  def create
    @field = Field.new(field_params)
    if @field.save
      redirect_to @field
    else
      render action: :new
    end
  end

  def edit
    gon.field_shape = @field.geo_json_with_props
  end

  def update
    if @field.update_attributes(field_params)
      redirect_to @field
    else
      render action: :edit
    end
  end

  def destroy
    @field.destroy
    redirect_to root_path
  end

  private
  def field_params
    params.fetch(:field).permit(:name, :geo_json)
  end

  def set_field
    @field = Field.find params[:id]
  end
end
