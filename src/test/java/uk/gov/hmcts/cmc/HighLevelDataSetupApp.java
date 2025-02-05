package uk.gov.hmcts.cmc;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import uk.gov.hmcts.befta.dse.ccd.CcdEnvironment;
import uk.gov.hmcts.befta.dse.ccd.CcdRoleConfig;
import uk.gov.hmcts.befta.dse.ccd.DataLoaderToDefinitionStore;

import java.util.List;

public class HighLevelDataSetupApp extends DataLoaderToDefinitionStore {
    private static final Logger logger = LoggerFactory.getLogger(HighLevelDataSetupApp.class);

    private static final String definitionsPath = "ccd_definition";

    private static final CcdRoleConfig[] CCD_ROLES_NEEDED_FOR_CMC = {
            new CcdRoleConfig("citizen", "PUBLIC"),
            new CcdRoleConfig("caseworker-cmc", "PUBLIC"),
            new CcdRoleConfig("caseworker-cmc-solicitor", "PUBLIC"),
            new CcdRoleConfig("caseworker-cmc-systemupdate", "PUBLIC"),
            new CcdRoleConfig("caseworker-cmc-rparobot", "PUBLIC"),
            new CcdRoleConfig("letter-holder", "PUBLIC"),
            new CcdRoleConfig("caseworker-autotest1", "PUBLIC"),
            new CcdRoleConfig("caseworker-cmc-anonymouscitizen", "PUBLIC"),
            new CcdRoleConfig("caseworker-cmc-judge", "PUBLIC"),
            new CcdRoleConfig("caseworker-cmc-legaladvisor", "PUBLIC"),
            new CcdRoleConfig("caseworker-cmc-pcqextractor", "PUBLIC"),
            new CcdRoleConfig("payments", "PUBLIC"),
            new CcdRoleConfig("TTL-admin", "PUBLIC")
    };

    public HighLevelDataSetupApp(CcdEnvironment dataSetupEnvironment) {
        super(dataSetupEnvironment, definitionsPath);
    }

    public static void main(String[] args) throws Throwable {
        main(HighLevelDataSetupApp.class, args);
    }

    @Override
    public void addCcdRoles() {
        for (CcdRoleConfig roleConfig : CCD_ROLES_NEEDED_FOR_CMC) {
            try {
                logger.info("\n\nAdding CCD Role {}.", roleConfig);
                addCcdRole(roleConfig);
                logger.info("\n\nAdded CCD Role {}.", roleConfig);
            } catch (Exception e) {
                logger.error("\n\nCouldn't add CCD Role {} - Exception: {}.\n\n", roleConfig, e);
                if (!shouldTolerateDataSetupFailure()) {
                    throw e;
                }
            }
        }
    }

    @Override
    protected void doLoadTestData() {
        List<String> definitionFileResources = getAllDefinitionFilesToLoadAt(definitionsPath);
        CcdEnvironment currentEnv = (CcdEnvironment) getDataSetupEnvironment();
        try {
            if (currentEnv != null) {
                addCcdRoles();
                importDefinitions();
            } else {
                definitionFileResources.forEach(file ->
                    logger.info("definition file \"" + file + "\" is skipped on " + currentEnv));
            }
        } catch (Exception e) {
            logger.info("Error on uploading ccd definition file - " + e.getMessage());
            // exit the process to fail jenkins pipeline
            System.exit(1);
        }
    }
}