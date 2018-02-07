# custom-marc-exporter

## Background:

Sample custom MARC exporter demonstarted at the 2018 Code4Lib pre-conference workshop.  Enables following customizations to MARC exporter.

### 008/15-17 (Country Code):
Currently defined in output as “xx”=Unknown. Should be the location of the repository. Define as “dcu”=District of Columbia.

### Leader/18 (Descriptive Cataloging Form):
Currently defined as “u”=Unknown. Should be “i”=ISBD punctuation is used.

### 040 (Cataloging Source):
Currently very generic, but will be defined as:
<datafield tag=”040” ind2=” “ ind1=” “>
	<subfield code=”a”>psels</subfield>
	<subfield code=”b”>eng</subfield>
	<subfield code=”e”>dacs</subfield>
	<subfield code=”c”>psels</subfield>
</datafield>

### 245, subfield f (Date):
This is where the date info is currently mapped to. However, we want it mapped to the 264, subfield c:

264, subfield c (Date):
<datafield tag=”264” ind2=”0“ ind1=” “>
	<subfield code=”c”>[whatever the date info is].</subfield>
</datafield>

### 852 (Location):
Currently rather generic. Will be defined:
<datafield tag=”852” ind2=” “ ind1=” “>
	<subfield code=”a”>Code4Lib 2018</subfield>
	<subfield code=”e”>2500 Calvert St NW, Washington, DC 20008</subfield>
	<subfield code=”c”>[Collection number]</subfield>
</datafield>

## To install:

1. Stop the application
2. Clone plugin into the _archivesspace/plugins_ directory
3. Modify config.rb (in _archivesspace/config_) to list custom-marc-exporter
4. Restart the application /archivesspace/archivesspace.sh
