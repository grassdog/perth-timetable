curl -o google_transit.zip http://www.transperth.wa.gov.au/TimetablePDFs/GoogleTransit/google_transit.zip
mkdir -p rawdata
unzip -o google_transit.zip -d rawdata
rm google_transit.zip

