import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import api from '../../api';

interface PerkType {
  perkTypeID: number;
  typeName: string;
  description: string;
  isActive: boolean;
  createdBy: number;
  createdAt: string;
  updatedBy: number;
  updatedAt: string;
}

const initialFormData: PerkType = {
  perkTypeID: 0,
  typeName: '',
  description: '',
  isActive: true,
  createdBy: 0, // This will be set dynamically
  createdAt: new Date().toISOString(),
  updatedBy: 0, // This will be set dynamically
  updatedAt: new Date().toISOString(),
};

const PerkTypeForm = () => {
  const { id } = useParams<{ id?: string }>();
  const [formData, setFormData] = useState<PerkType>(initialFormData);
  const [alert, setAlert] = useState<{ type: 'success' | 'error', message: string } | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    // Simulated function to get the logged-in user's ID
    const fetchUserId = async () => {
      // Replace with your actual logic to fetch the logged-in user's ID
      return 1; // Example: Replace with actual user ID
    };

    const fetchPerkType = async () => {
      const userId = await fetchUserId();
      if (id) {
        try {
          const response = await api.get(`/PerkTypes/${id}`);
          setFormData({
            ...response.data,
            updatedBy: userId,
            updatedAt: new Date().toISOString(),
          });
        } catch (error) {
          console.error('Error fetching perk type data:', error);
        }
      } else {
        setFormData(prev => ({
          ...prev,
          createdBy: userId,
          createdAt: new Date().toISOString(),
          updatedBy: userId,
          updatedAt: new Date().toISOString(),
        }));
      }
    };

    fetchPerkType();
  }, [id]);
  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value, type, checked } = e.target as HTMLInputElement;
  
    setFormData(prevData => ({
      ...prevData,
      [name]: type === 'checkbox' ? checked : value,
    }));
  };
  
  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    try {
      if (id) {
        // Update existing perk type
        await api.put(`/PerkTypes/${id}`, formData);
        setAlert({ type: 'success', message: 'PerkType updated successfully!' });
      } else {
        // Create new perk type
        const response = await api.post('/PerkTypes', formData);
        setFormData(response.data);
        setAlert({ type: 'success', message: 'PerkType created successfully!' });
      }

      // Optionally reset the form after successful submission
      setFormData(initialFormData);
      navigate('/perktypes');
    } catch (error) {
      console.error('Error saving perk type:', error);
      setAlert({ type: 'error', message: 'Error saving perk type. Please try again later.' });
    }
  };

  const handleBackClick = () => {
    navigate('/perktypes');
  };

  return (
    <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
      <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
        <h3 className="font-medium text-black dark:text-white">
          {id ? 'Update PerkType' : 'Create PerkType'}
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
          <label htmlFor="typeName" className="mb-3 block text-black dark:text-white">
            Type Name
          </label>
          <input
            type="text"
            id="typeName"
            name="typeName"
            value={formData.typeName}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="description" className="mb-3 block text-black dark:text-white">
            Description
          </label>
          <textarea
            id="description"
            name="description"
            value={formData.description}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="isActive" className="mb-3 block text-black dark:text-white">
            Is Active
          </label>
          <input
            type="checkbox"
            id="isActive"
            name="isActive"
            checked={formData.isActive}
            onChange={handleChange}
            className="w-4 h-4"
          />
        </div>

        <button
          type="submit"
          className="bg-primary text-white py-3 px-6 rounded-lg mt-6 mx-auto hover:bg-opacity-90 focus:outline-none"
        >
          {id ? 'Update PerkType' : 'Create PerkType'}
        </button>
      </form>
    </div>
  );
};

export default PerkTypeForm;
