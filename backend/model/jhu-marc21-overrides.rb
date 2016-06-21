class MARCModel < ASpaceExport::ExportModel
  model_for :marc21

  include JSONModel

#20160621LJD: Leader - Change u at position 18 with i for ISBD per technical services.
  def self.from_resource(obj)
    marc = self.from_archival_object(obj)
    marc.apply_map(obj, @resource_map)
    marc.leader_string = "00000np$ a2200000 i 4500"
    marc.leader_string[7] = obj.level == 'item' ? 'm' : 'c'

    marc.controlfield_string = assemble_controlfield_string(obj)

    marc
  end

#20160621LJD: 008 - Change 'xx' at positions 15-16 with 'mdu' for Maryland per technical services.
def self.assemble_controlfield_string(obj)
  date = obj.dates[0] || {}
  string = obj['system_mtime'].scan(/\d{2}/)[1..3].join('')
  string += obj.level == 'item' && date['date_type'] == 'single' ? 's' : 'i'
  string += date['begin'] ? date['begin'][0..3] : "    "
  string += date['end'] ? date['end'][0..3] : "    "
  string += "mdu"
  17.times { string += ' ' }
  string += (obj.language || '|||')
  string += ' d'

  string
end

#20160620LJD: 040 - Hard code JHE for 040 $a $e per technical services; add 'eng' to subfield b.
  def handle_repo_code(repository)
    repo = repository['_resolved']
    return false unless repo

    df('852', ' ', ' ').with_sfs(
                        ['a', 'The Johns Hopkins University'],
                        ['b', repo['name']],
                        ['e', '3400 N. Charles St. Baltimore, MD 21218']
                      )
    df('040', ' ', ' ').with_sfs(['a', 'JHE'], ['b', 'eng'], ['c', 'JHE'])
  end

#20160621LJD: Change date from 245$f to 264$c per technical services.
def handle_dates(dates)
  return false if dates.empty?

  dates = [["single", "inclusive", "range"], ["bulk"]].map {|types|
    dates.find {|date| types.include? date['date_type'] }
  }.compact

  dates.each do |date|
    code = 'c'
    val = nil
    if date['date_type'] == 'bulk'
      val = nil
    elsif date['expression']
        val = date['expression']
    elsif date['date_type'] == 'single'
      val = date['begin']
    else
      val = "#{date['begin']} - #{date['end']}"
    end

    df('264', ' ', '0').with_sfs([code, val])
  end
end

#20160620LJD: Prefercite incorrectly mapped to 534; changed to 524
  def handle_notes(notes)

    notes.each do |note|

      marc_args = case note['type']

                  when 'prefercite'
                    ['524', '8', ' ', 'a']
                  end
    end
  end

end
