// src/store/reducer.js
import { INQUIRY } from './actionTypes';

const initialState = {
  inquiries: {}, // Initial state for response data
};

const aiHandlers = {
  [INQUIRY]: (state, action) => ({
      ...state,
      inquiries: {
          ...state.inquiries,
          [action.payload.id]: action.payload,
      }, 
  }),
};

const reducer = (state = initialState, action) => {
  const handler = aiHandlers[action.type];
  return handler ? handler(state, action) : state;
};

export default reducer;