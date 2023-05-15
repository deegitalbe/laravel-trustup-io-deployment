#!/usr/bin/env node

import {
  useConfirm,
  useCurrentPath,
  useGenerator,
  useDisplayJson,
  usePackageStubsPath,
  usePrompt,
  useSentence,
} from "@henrotaym/scaffolding-utils";
import { useAppUrl, useLaravelAppKey } from "./utils";

const useStubsPath = usePackageStubsPath(
  "@deegital/laravel-trustup-io-deployment"
);

const useScaffolding = () => {
  useSentence("Hi there 👋");
  useSentence("Let's scaffold a new laravel kubernetes deployment 🎉");

  const folder = usePrompt("Folder location [.]", ".");
  const location = useCurrentPath(folder);

  const appKey = usePrompt("App key");
  const laravelAppKey = useLaravelAppKey(appKey);
  const appEnv = usePrompt("App environment [production]", "production");
  const isProduction = appEnv === "production";
  const defaultAppUrl = useAppUrl(isProduction, appKey);
  const appUrl = usePrompt(`App url [${defaultAppUrl}]`, defaultAppUrl);
  const branchName = isProduction ? "main" : "release/v*";

  const terraformCloudOrganizationName = usePrompt(
    "Terraform cloud organization [deegital]",
    "deegital"
  );
  const githubOrganizationName = usePrompt(
    `Github organization [${terraformCloudOrganizationName}be]`,
    `${terraformCloudOrganizationName}be`
  );
  const dockerhubOrganizationName = usePrompt(
    "Dockerhub organization [henrotaym]",
    "henrotaym"
  );

  const cloudflareKey = usePrompt("Cloudflare key");

  const flareKey = usePrompt("Flare key");

  const mediaUrl = usePrompt(
    "Media url [media.trustup.io]",
    "media.trustup.io"
  );
  const messagingUrl = usePrompt(
    "Messaging url [messaging.trustup.io]",
    "messaging.trustup.io"
  );
  const authUrl = usePrompt("Auth url [auth.trustup.io]", "auth.trustup.io");

  const displayedData = {
    location,
    appKey,
    appEnv,
    appUrl,
    terraformCloudOrganizationName,
    dockerhubOrganizationName,
    githubOrganizationName,
    cloudflareKey,
    flareKey,
    mediaUrl,
    messagingUrl,
    authUrl,
  };

  useDisplayJson(displayedData);

  const isConfirmed = useConfirm("Is it correct ? ");

  if (!isConfirmed) {
    useSentence("Scaffolding was cancelled ❌");
    useSentence("Come back when you're ready 😎");
    return;
  }

  const generator = useGenerator({
    ...displayedData,
    laravelAppKey,
    branchName,
  });

  generator.copy(useStubsPath(), location);

  useSentence("Successfully scaffolded project ✅");
  useSentence("Happy coding 🤓");
};

export default useScaffolding;
