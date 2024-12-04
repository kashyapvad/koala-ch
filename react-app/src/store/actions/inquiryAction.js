import { INQUIRY } from '../actionTypes';

export const setInquiryData = (data) => ({
    type: INQUIRY,
    payload: data,
});