import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import api from '../../api';

interface Country {
  countryID: number;
  countryName: string;
  createdBy: number;
  createdAt: string;
  updatedBy: number;
  updatedAt: string;
}

const initialFormData: Country = {
  countryID: 0,
  countryName: '',
  createdBy: 0,
  createdAt: new Date().toISOString(), // Ensure default date is valid
  updatedBy: 0,
  updatedAt: new Date().toISOString(), // Ensure default date is valid
};

const CountryForm = () => {
  const { id } = useParams();
  const [formData, setFormData] = useState<Country>(initialFormData);
  const [alert, setAlert] = useState<{ type: 'success' | 'error'; message: string } | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchCountry = async () => {
      if (id !== null && id !== undefined) {
        try {
          const response = await api.get(`/Countries/${id}`);
          setFormData({
            ...response.data,
            updatedBy: getUserIdFromStorage() || 0,
            updatedAt: getCurrentDateTime(),
          });
        } catch (error) {
          console.error('Error fetching country data:', error);
        }
      }
    };

    fetchCountry();
  }, [id]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: name === 'countryID' ? parseInt(value, 10) : value,
    });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const userId = getUserIdFromStorage() || 0;
    const currentTime = getCurrentDateTime();

    // Validate required field
    if (!formData.countryName.trim()) {
      setAlert({ type: 'error', message: 'Country Name is required.' });
      return;
    }

    const data = {
      ...formData,
      updatedBy: userId,
      updatedAt: currentTime,
      createdBy: formData.createdBy || userId,
      createdAt: formData.createdAt || currentTime,
    };

    try {
      if (id !== null && id !== undefined) {
        // Update existing country
        await api.put(`/Countries/${formData.countryID}`, data);
        setAlert({ type: 'success', message: 'Country updated successfully!' });
      } else {
        // Create new country
        const response = await api.post('/Countries', data);
        setFormData(response.data);
        setAlert({ type: 'success', message: 'Country created successfully!' });
      }

      setFormData(initialFormData);
      navigate('/country');
    } catch (error) {
      console.error('Error saving country:', error);
      setAlert({ type: 'error', message: 'Error saving country. Please try again later.' });
    }
  };

  const handleBackClick = () => {
    navigate('/country');
  };

  const getUserIdFromStorage = (): number | null => {
    const userId = localStorage.getItem('userId');
    return userId ? parseInt(userId, 10) : null;
  };

  const getCurrentDateTime = (): string => {
    const date = new Date();
    return date.toISOString(); // Ensure ISO format
  };

  return (
    <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
      <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
        <h3 className="font-medium text-black dark:text-white">
          {id ? 'Update Country' : 'Create Country'}
        </h3>
        <button
          onClick={handleBackClick}
          className="bg-secondary text-white py-2 px-4 rounded-lg hover:bg-opacity-90"
        >
          Back
        </button>
      </div>

      {alert && (
        <div className={`mt-4 mx-6.5 ${alert.type === 'success' ? 'text-green-700 bg-green-100' : 'text-red-700 bg-red-100'} py-2 px-4 rounded-lg`}>
          {alert.message}
        </div>
      )}

      <form onSubmit={handleSubmit} className="flex flex-col gap-5.5 p-6.5">
        <div>
          <label htmlFor="countryName" className="mb-3 block text-black dark:text-white">
            Country Name
          </label>
          <input
            type="text"
            id="countryName"
            name="countryName"
            value={formData.countryName}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        {/* Hidden fields */}
        <input type="hidden" name="createdBy" value={formData.createdBy || getUserIdFromStorage() || 0} />
        <input type="hidden" name="createdAt" value={formData.createdAt || getCurrentDateTime()} />
        <input type="hidden" name="updatedBy" value={getUserIdFromStorage() || 0} />
        <input type="hidden" name="updatedAt" value={getCurrentDateTime()} />

        <button
          type="submit"
          className="bg-primary text-white py-3 px-6 rounded-lg mt-6 mx-auto hover:bg-opacity-90 focus:outline-none"
        >
          {id ? 'Update Country' : 'Create Country'}
        </button>
      </form>
    </div>
  );
};

export default CountryForm;
