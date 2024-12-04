import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux'; 
import { put, trigger } from './services/apiService';
import { setInquiryData } from './store/actions/inquiryAction';

const Home = () => {
    const [emailBody, setEmailBody] = useState('');
    const [responseMessage, setResponseMessage] = useState('');
    const [isLoading, setIsLoading] = useState(false);
    const inquiry = useSelector((state) => {
        const inquiriesArray = Object.values(state.inquiries);
        return inquiriesArray[inquiriesArray.length - 1];
    });
    const message = inquiry?.messages?.[0];
    const [emailResponse, setEmailResponse] = useState(message?.user_copy);
    const messageId = message?.id;
    const dispatch = useDispatch();

    const hiHandleEmailBodyChange = (event) => {
        setEmailBody(event.target.value);
    };

    const hiHandleUserCopyChange = (event) => {
        const newUserCopy = event.target.value;
        setEmailResponse(newUserCopy);
        const updatedMessages = inquiry.messages.map((message) => {
            return message.id === messageId
                ? { ...message, user_copy: newUserCopy }
                : message;
        });

        const updatedInquiry = {
            ...inquiry,
            messages: updatedMessages,
        };
        dispatch(setInquiryData(updatedInquiry));
    };

    const handleUpdateUserCopy = async () => {
        setIsLoading(true);
        setResponseMessage("");
        try {
            const endpoint = `ai/messages/${messageId}`;
            await put(endpoint, { message: inquiry?.messages?.[0] });
        } catch (error) {
            setResponseMessage(error.message);
        } finally {
            setIsLoading(false); // Stop loading
        }
    };

    const handleCraftResponse = async () => {
        setIsLoading(true);
        setResponseMessage("")
        try {
            const response = await trigger('inquiries', 'email_crafter', { email_body: emailBody });
            setEmailResponse(response?.messages?.[0]?.user_copy);
            dispatch(setInquiryData(response));
        } catch (error) {
          setResponseMessage(error.message);
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div className="container mt-5">
            <h1 className="text-center mb-4">Email Body Input</h1>
            <div className="form-group">
                <textarea
                    className="form-control"
                    value={emailBody}
                    onChange={hiHandleEmailBodyChange}
                    rows="10"
                    placeholder="Paste your email body here..."
                />
            </div>
            <button
                className="btn btn-primary btn-block mt-3"
                onClick={handleCraftResponse}
                disabled={isLoading} // Disable when loading
            >
                {isLoading ? 'Crafting...' : 'Craft a Response'}
            </button>
            {responseMessage && <div className="alert alert-info mt-3">{responseMessage}</div>}
            {emailResponse && (
                <div className="form-group">
                    <label htmlFor="emailResponse">Email Response:</label>
                    <textarea
                        id="emailResponse"
                        className="form-control"
                        value={emailResponse}
                        onChange={hiHandleUserCopyChange}
                        style={{ width: '100%', height: '560px' }} // Optional: Set a specific height and width
                        placeholder="Edit your email response here..."
                    />
                </div>
            )}
            {emailResponse && (
                <button
                    className="btn btn-primary mt-3"
                    onClick={handleUpdateUserCopy}
                    disabled={isLoading} // Disable when loading
                >
                    {isLoading ? 'Updating...' : 'Update'}
                </button>
            )}
        </div>
    );
};

export default Home;