class MARCModel < ASpaceExport::ExportModel
  model_for :marc21

  include JSONModel

#20160621LJW: Leader - Change u at position 18 with i for ISBD per technical services.
  def self.from_resource(obj)
    marc = self.from_archival_object(obj)
    marc.apply_map(obj, @resource_map)
    marc.leader_string = "00000np$aa2200000 i 4500"
    marc.leader_string[7] = obj.level == 'item' ? 'm' : 'c'

    marc.controlfield_string = assemble_controlfield_string(obj)

    marc
  end

#20160621LJW: 008 - Change 'xx' at positions 15-16 with 'dcu' for Disctric of Columbia.
def self.assemble_controlfield_string(obj)
  date = obj.dates[0] || {}
  string = obj['system_mtime'].scan(/\d{2}/)[1..3].join('')
  string += obj.level == 'item' && date['date_type'] == 'single' ? 's' : 'i'
  string += date['begin'] ? date['begin'][0..3] : "    "
  string += date['end'] ? date['end'][0..3] : "    "
  string += "dcu"
  17.times { string += ' ' }
  string += (obj.language || '|||')
  string += ' d'

  string
end

#20160620LJD: 040 - Hard code psels (Susquehanna University) for 040 $a $e per technical services; add 'eng' to subfield b.  Add repository address.
  def handle_repo_code(repository)
    repo = repository['_resolved']
    return false unless repo

    df('852', ' ', ' ').with_sfs(
                        ['a', 'Code4Lib 2018'],
                        ['b', repo['name']],
                        ['e', '2500 Calvert St NW, Washington, DC 20008']
                      )
    df('040', ' ', ' ').with_sfs(['a', 'psels'], ['b', 'eng'], ['c', 'psels'])
  end

#20160621LJD: Change date from 245$f to 264$c:
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
