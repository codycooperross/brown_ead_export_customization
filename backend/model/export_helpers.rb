module ASpaceExport
  # Convenience methods that will work for resource
  # or archival_object models during serialization
  module ArchivalObjectDescriptionHelpers

    def archdesc_dates
      unless @archdesc_dates
        results = []
        dates = self.dates || []
        dates.each do |date|
          normal = ""
          unless date['begin'].nil?
            normal = "#{date['begin']}/"
            normal_suffix = (date['date_type'] == 'single' || date['end'].nil? || date['end'] == date['begin']) ? date['begin'] : date['end']
            normal += normal_suffix ? normal_suffix : ""
          end
          type = ( date['date_type'] == 'inclusive' ) ? 'inclusive' :  ( ( date['date_type'] == 'single') ? nil : 'bulk')
          content = if date['expression']
                    date['expression']
                  elsif date['end'].nil? || date['end'] == date['begin']
                    date['begin']
                  else
                    "#{date['begin']}-#{date['end']}"
                  end

          atts = {}
          atts[:type] = type if type
          atts[:certainty] = date['certainty'] if date['certainty']
          atts[:normal] = normal unless normal.empty?
          atts[:era] = date['era'] if date['era']
          atts[:calendar] = date['calendar'] if date['calendar']
          atts[:datechar] = date['label'] if date['label']

          results << {:content => content, :atts => atts}
        end

        @archdesc_dates = results
      end

      @archdesc_dates
    end
  end

  end

