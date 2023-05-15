#!/usr/bin/env node

const useAppUrl = (isProduction: boolean, appKey: string) => {
  const splittedAppKey = appKey
    .replace("trustup-io", "io-trustup")
    .replace("worksite", "pro-worksite")
    .split("-")
    .reverse();

  if (!isProduction) splittedAppKey.unshift("staging");
  return splittedAppKey.join(".");
};

export default useAppUrl;
