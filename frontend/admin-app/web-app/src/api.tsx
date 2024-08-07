// api.ts

import axios from 'axios';

// Function to get JWT token from localStorage
const getToken = (): string | null => {
  return localStorage.getItem('accessToken');
};

// Create an instance of axios with base URL
const api = axios.create({
  baseURL: 'https://localhost:44320/api',
});

// Request interceptor to add JWT token to headers
api.interceptors.request.use(
  (config) => {
    const token = getToken();
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export default api;
