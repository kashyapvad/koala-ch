import { configureStore } from '@reduxjs/toolkit'; // Import configureStore
import rootReducer from './reducer'

const store = configureStore({ // Use configureStore instead of createStore
    reducer: rootReducer,
});

export default store;