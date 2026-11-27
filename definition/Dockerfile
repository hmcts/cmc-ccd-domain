# ---- Base image - order important ----
FROM hmctsprod.azurecr.io/ccd/definition-processor:latest@sha256:0789f4e90bb79636c8daee9aa854cc385f37989809eb1ae21a19aa10ef59144a AS base

# ----        Runtime image         ----
FROM hmctsprod.azurecr.io/ccd/definition-importer:latest@sha256:dce0d223602850d364f436ed6411af424da45c7f9230fbe673b1a85c41acaebf AS runtime
RUN apk add --no-cache curl jq zip unzip git
COPY --from=base . .
COPY ./definition/data /data

CMD cd /opt/ccd-definition-processor && yarn json2xlsx -D /data/sheets -o /cmc-ccd.xlsx && "/wait" && "/scripts/upload-definition.sh"
