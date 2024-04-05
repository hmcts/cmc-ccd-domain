package uk.gov.hmcts.cmc;

import uk.gov.hmcts.befta.dse.ccd.CcdEnvironment;
import uk.gov.hmcts.befta.dse.ccd.DataLoaderToDefinitionStore;

import java.util.List;

public class HighLevelDataSetupApp extends DataLoaderToDefinitionStore {

    private static final String definitionsPath = "ccd_definition";

    public HighLevelDataSetupApp(CcdEnvironment dataSetupEnvironment) {
        super(dataSetupEnvironment, definitionsPath);
    }

    public static void main(String[] args) throws Throwable {
        main(HighLevelDataSetupApp.class, args);
    }

    @Override
    protected void doLoadTestData() {
        List<String> definitionFileResources = getAllDefinitionFilesToLoadAt(definitionsPath);
        CcdEnvironment currentEnv = (CcdEnvironment) getDataSetupEnvironment();
        try {
            if (currentEnv != null) {
                importDefinitions();
            } else {
                definitionFileResources.forEach(file ->
                    System.out.println("definition file \"" + file + "\" is skipped on " + currentEnv));
            }
        } catch (Exception e) {
            System.out.println("Error on uploading ccd definition file - " + e.getMessage());
            // exit the process to fail jenkins pipeline
            System.exit(1);
        }
    }
}