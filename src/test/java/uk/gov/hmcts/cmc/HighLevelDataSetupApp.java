package uk.gov.hmcts.cmc;

import uk.gov.hmcts.befta.dse.ccd.CcdEnvironment;
import uk.gov.hmcts.befta.dse.ccd.DataLoaderToDefinitionStore;

import java.util.Locale;

public class HighLevelDataSetupApp extends DataLoaderToDefinitionStore {

    private final CcdEnvironment environment;

    public HighLevelDataSetupApp(CcdEnvironment dataSetupEnvironment) {
        super(dataSetupEnvironment);
        environment = dataSetupEnvironment;
    }

    public static void main(String[] args) throws Throwable {
        main(HighLevelDataSetupApp.class, args);
    }

    private String getDefinitionFile() {
        String environmentName = environment.name().toLowerCase(Locale.UK);
        return String.format("definition/xlsx/cmc-ccd-%s.xlsx", environmentName);
    }

    @Override
    public void importDefinitions() {
        importDefinitionsAt(getDefinitionFile());
    }

    @Override
    protected void doLoadTestData() {
        String definitionFile = getDefinitionFile();
        CcdEnvironment currentEnv = (CcdEnvironment) getDataSetupEnvironment();
        try {
            if (currentEnv != null) {
                importDefinitions();
            } else {
                System.out.println("definition file \"" + definitionFile + "\" is skipped on " + currentEnv);
            }
        } catch (Exception e) {
            System.out.println("Error on uploading ccd definition file - " + e.getMessage());
            // exit the process to fail jenkins pipeline
            System.exit(1);
        }
    }
}