const handleError = (res, statusCode, message) => {
  res.status(statusCode).json({ error: message });
};

export default { handleError };