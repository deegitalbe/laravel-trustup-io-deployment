#!/usr/bin/env node

import {
  useConfirm,
  useCurrentPath,
  useGenerator,
  useDisplayJson,
  usePackageStubsPath,
  usePrompt,
  useSentence,
  useLastFolderName,
} from "@henrotaym/scaffolding-utils";

const useStubsPath = usePackageStubsPath(
  "@deegital/laravel-trustup-io-deployment"
);

const useScaffolding = () => {
  useSentence("Hi there 👋");
  useSentence("Let's scaffold a new laravel kubernetes deployment 🎉");

  const folder = usePrompt("Folder location [.]", ".");
  const location = useCurrentPath(folder);
  const defaultAppKey = useLastFolderName(location);
  const appKey = usePrompt(`App key [${defaultAppKey}]`, defaultAppKey);
  const dockerhubOrganizationName = usePrompt(
    "Dockerhub organization [henrotaym]",
    "henrotaym"
  );

  const displayedData = {
    location,
    appKey,
    dockerhubOrganizationName,
  };

  useDisplayJson(displayedData);

  const isConfirmed = useConfirm("Is it correct ? ");

  if (!isConfirmed) {
    useSentence("Scaffolding was cancelled ❌");
    useSentence("Come back when you're ready 😎");
    return;
  }

  const generator = useGenerator(displayedData);

  generator.copy(useStubsPath(), location);

  useSentence("Successfully scaffolded project ✅");
  useSentence("Happy coding 🤓");
};

export default useScaffolding;
