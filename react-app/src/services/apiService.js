// src/services/apiService.js
import axios from 'axios';

const API_URL = process.env.KOALA_API_ENDPOINT || 'http://localhost:3000/api/v1'

const apiClient = axios.create({
    baseURL: API_URL,
    headers: {
        'Content-Type': 'application/json',
         "Access-Control-Allow-Origin":"*",
    },
});

// Generic function to handle GET requests
export const get = async (endpoint) => {
    const response = await apiClient.get(endpoint);
    return response.data;
};

// Generic function to handle POST requests
export const post = async (endpoint, data) => {
    const response = await apiClient.post(endpoint, data);
    return response.data;
};

export const put = async (endpoint, data) => {
  const response = await apiClient.put(endpoint, data);
  return response.data;
};

// Generic function to handle DELETE requests
export const del = async (endpoint) => {
    const response = await apiClient.delete(endpoint);
    return response.data;
};

export const trigger = async (resource, type, data) => {
  const endpoint = `ai/${resource}/triggers/${type}`
  const payload = {
    event: {
      data: data
    }
  }
  return post(endpoint, payload)
};