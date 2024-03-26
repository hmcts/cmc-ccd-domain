package uk.gov.hmcts.cmc;

import uk.gov.hmcts.befta.dse.ccd.CcdEnvironment;
import uk.gov.hmcts.befta.dse.ccd.DataLoaderToDefinitionStore;

import java.util.List;
import java.util.Locale;

public class HighLevelDataSetupApp extends DataLoaderToDefinitionStore {

    public HighLevelDataSetupApp(CcdEnvironment dataSetupEnvironment) {
        super(dataSetupEnvironment);
    }

    public static void main(String[] args) throws Throwable {
        main(HighLevelDataSetupApp.class, args);
    }

    @Override
    protected List<String> getAllDefinitionFilesToLoadAt(String definitionsPath) {
        String environmentName = environment.name().toLowerCase(Locale.UK);
        return List.of(String.format("build/release/civil-ccd-%s.xlsx", environmentName));
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