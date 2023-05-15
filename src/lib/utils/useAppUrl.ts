const useAppUrl = (isProduction: boolean, appKey: string) => {
  const splittedAppKey = appKey.split("-").reverse();
  if (!isProduction) splittedAppKey.unshift("staging");
  return splittedAppKey.join(".");
};

export default useAppUrl;
