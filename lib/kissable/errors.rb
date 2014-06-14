module Kissable
  class TooManyGroupsError < ArgumentError
    def message
      "The max number of groups is #{Kissable::AB::MAX_GROUP_COUNT}"
    end
  end

  class OneGroupError < ArgumentError
    def message
      'A minimium of two groups are required'
    end
  end
end
