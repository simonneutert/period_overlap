module PeriodOverlap
  class Validator
    attr_reader :model, :model_starting_attr, :model_ending_attr, :starting_attr, :ending_attr, :additional_query

    def initialize(model, model_starting_attr, model_ending_attr, starting_attr, ending_attr, additional_query)
      @self_id = model.id
      @model = model.class.name.constantize
      @model_starting = model_starting_attr
      @model_ending = model_ending_attr
      @starting = starting_attr
      @ending = ending_attr
      @additional_query = additional_query
      @query_inside_outside = @model.where("#{@model_starting} <= ? AND #{@model_ending} >= ? OR #{@model_starting} >= ? AND #{@model_ending} <= ?", @starting, @ending, @starting, @ending)
      @query_overlap_before = @model.where("#{@model_starting} <= ? AND #{@model_ending} >= ? AND #{@model_ending} <= ?", @starting, @starting, @ending)
      @query_overlap_after = @model.where("#{@model_starting} <= ? AND #{@model_ending} >= ? AND #{@model_ending} >= ?", @ending, @ending, @starting)
      if @self_id # skip self if present!
        @query_inside_outside = @query_inside_outside.where.not(id: @self_id)
        @query_overlap_before = @query_overlap_before.where.not(id: @self_id)
        @query_overlap_after = @query_overlap_after.where.not(id: @self_id)
      end
      unless @additional_query.blank?
        @query_inside_outside = @query_inside_outside.where(@additional_query)
        @query_overlap_before = @query_overlap_before.where(@additional_query)
        @query_overlap_after = @query_overlap_after.where(@additional_query)
      end
    end

    def overlap?
      return unless block_given?
      case
      when @query_inside_outside.any?
        yield
        @query_inside_outside
      when @query_overlap_before.any?
        yield
        @query_overlap_before
      when @query_overlap_after.any?
        yield
        @query_overlap_after
      end
    end

  end
end
