import { createHmac } from "crypto";

const useLaravelAppKey = (secret: string) => {
  const key = createHmac("sha256", secret);
  return `base64:${key.digest("base64")}`;
};

export default useLaravelAppKey;
