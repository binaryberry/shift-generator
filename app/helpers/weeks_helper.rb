module WeeksHelper

  def span_class(assignment_to_display)
    if assignment_to_display.try(:person).try(:active)
      assignment_to_display.try(:person).try(:team).try(:parameterize)
    else
      "assignment-missing"
    end
  end
end
