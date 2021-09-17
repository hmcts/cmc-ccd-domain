# ---- Base image - order important ----
FROM hmctspublic.azurecr.io/ccd/definition-processor:latest as base

# ----        Runtime image         ----
FROM hmctspublic.azurecr.io/ccd/definition-importer:latest as runtime
RUN apk add --no-cache curl jq zip unzip git
COPY --from=base . .
COPY ./definition/data /data

EXPOSE 4000
CHMOD 777 /cmc-ccd.xlsx
CMD cd /opt/ccd-definition-processor && yarn json2xlsx -D /data/sheets -o /cmc-ccd.xlsx && "/wait" && "/scripts/upload-definition.sh" && [ "empty.jar" ]
