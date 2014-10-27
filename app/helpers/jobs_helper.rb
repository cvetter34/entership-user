module JobsHelper

  def options_for_experience_level
    levels = [ [ "Select an experience level", "" ] ] + Job.experience_levels.map do |level|
      [ level.titleize, level ]
    end
    options_for_select( levels )
  end

  def options_for_contract_type
    types = Job.contract_types.map do |t|
      [ t.titleize, t ]
    end
    options_for_select( types )
  end
end
