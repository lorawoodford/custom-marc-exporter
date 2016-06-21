# jhu-marc-exporter

## To install:

Stop the application
Clone plugin into the archivesspace/plugins directory
Modify config.rb (in archivesspace/config) to list jhu-marc-exporter
Restart the application /archivesspace/archivesspace.sh

Enables following customizations to MARC exporter per Chris' email and meeting of 6/20/2016:

## ArchivesSpace MARCXML Output Issues
Below are listed the issues with the current ArchivesSpace MARCXML outputs. All of these are relatively minor and if fixing them would be a major hassle, it’s probably not worth it, with one exception, that being the 040. Currently the 040 field is opened with an XML tag, but is not closed, so whatever comes after it, in this case the 245 field, is mapped to the 040 instead (basically, the collection title is being mapped to a place where it really should not go). As far as the rest of the record, I am modelling my MARC records for archival materials on several presentations given my Corey Nimer (models which appear to reflect best practices of the community).

## 008/15-17 (Country Code):
Currently defined in output as “xx”=Unknown. Should be the location of the repository. Define as “mdu”=Maryland.

## Leader/18 (Descriptive Cataloging Form):
Currently defined as “u”=Unknown. Should be “i”=ISBD punctuation is used.

## 040 (Cataloging Source):
Currently a mess! The XML is incorrect, in that it doesn’t end the field, so data that should go in the 245 field goes here instead. Should be defined:
<datafield tag=”040” ind2=” “ ind1=” “>
	<subfield code=”a”>JHE</subfield>
	<subfield code=”b”>eng</subfield>
	<subfield code=”e”>dacs</subfield>
	<subfield code=”c”>JHE</subfield>
</datafield>

## 245, subfield f (Date):
This is where the date info is currently mapped to. It should, however, be mapped to the 264, subfield c:

264, subfield c (Date):
<datafield tag=”264” ind2=”0“ ind1=” “>
	<subfield code=”c”>[whatever the date info is].</subfield>
</datafield>

## 852 (Location):
Currently rather generic. Should be defined:
<datafield tag=”852” ind2=” “ ind1=” “>
	<subfield code=”a”>The Johns Hopkins University</subfield>
	<subfield code=”b”>Special Collections</subfield>
	<subfield code=”e”>3400 N. Charles St. Baltimore, MD 21218</subfield>
	<subfield code=”c”>[Collection number]</subfield>
</datafield>

## 524 (Preferred Citation of Described Materials):
This is not currently present (but was present in AT outputs). If we want this info in the record, should be defined as (note, use of square brackets here is meant as literal, i.e., what is present below is what should actually be encoded):
<datafield tag=”524” ind2=” “ ind1=” “>
	<subfield code=”a”>[Name of folder or item], [Date], [Box number], [Folder number], [Collection title], [Collection number], Special Collections, The Johns Hopkins University</subfield>
</datafield>
