import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import api from '../../api'; // Adjust import based on your project structure

interface PerkType {
  perkTypeID: number;
  typeName: string;
}

interface Perk {
  perkID: number;
  perkType: number;
  perkName: string;
  description: string;
  value: number;
  startDate?: string;
  endDate?: string;
  isActive: boolean;
  minPurchaseAmount?: number;
  maxDiscountAmount?: number;
  createdBy: number;
  createdAt: string;
  updatedBy: number;
  updatedAt: string;
}

const initialFormData: Perk = {
  perkID: 0,
  perkType: 0,
  perkName: '',
  description: '',
  value: 0,
  startDate: new Date().toISOString(),
  endDate: new Date().toISOString(),
  isActive: true,
  minPurchaseAmount: 0,
  maxDiscountAmount: 0,
  createdBy: 0, // This will be set dynamically
  createdAt: new Date().toISOString(),
  updatedBy: 0, // This will be set dynamically
  updatedAt: new Date().toISOString(),
};

const PerkForm = () => {
  const { id } = useParams<{ id?: string }>();
  const [formData, setFormData] = useState<Perk>(initialFormData);
  const [perkTypes, setPerkTypes] = useState<PerkType[]>([]);
  const [alert, setAlert] = useState<{ type: 'success' | 'error', message: string } | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchUserId = async () => {
      // Simulated function to get the logged-in user's ID
      return 1; // Example: Replace with actual user ID
    };

    const fetchPerk = async () => {
      const userId = await fetchUserId();
      if (id) {
        try {
          const response = await api.get(`/Perks/${id}`);
          setFormData({
            ...response.data,
            updatedBy: userId,
            updatedAt: new Date().toISOString(),
          });
        } catch (error) {
          console.error('Error fetching perk data:', error);
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

    const fetchPerkTypes = async () => {
      try {
        const response = await api.get('/PerkTypes');
        setPerkTypes(response.data);
      } catch (error) {
        console.error('Error fetching perk types:', error);
      }
    };

    fetchPerk();
    fetchPerkTypes();
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
        // Update existing perk
        await api.put(`/Perks/${id}`, formData);
        setAlert({ type: 'success', message: 'Perk updated successfully!' });
      } else {
        // Create new perk
        const response = await api.post('/Perks', formData);
        setFormData(response.data);
        setAlert({ type: 'success', message: 'Perk created successfully!' });
      }

      // Optionally reset the form after successful submission
      setFormData(initialFormData);
      navigate('/perk');
    } catch (error) {
      console.error('Error saving perk:', error);
      setAlert({ type: 'error', message: 'Error saving perk. Please try again later.' });
    }
  };

  const handleBackClick = () => {
    navigate('/perk');
  };

  return (
    <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
      <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
        <h3 className="font-medium text-black dark:text-white">
          {id ? 'Update Perk' : 'Create Perk'}
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
          <label htmlFor="perkType" className="mb-3 block text-black dark:text-white">
            Perk Type
          </label>
          <select
            id="perkType"
            name="perkType"
            value={formData.perkType}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          >
            <option value="" disabled>Select Perk Type</option>
            {perkTypes.map(type => (
              <option key={type.perkTypeID} value={type.perkTypeID}>
                {type.typeName}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label htmlFor="perkName" className="mb-3 block text-black dark:text-white">
            Perk Name
          </label>
          <input
            type="text"
            id="perkName"
            name="perkName"
            value={formData.perkName}
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
          <label htmlFor="value" className="mb-3 block text-black dark:text-white">
            Value
          </label>
          <input
            type="number"
            id="value"
            name="value"
            value={formData.value}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="startDate" className="mb-3 block text-black dark:text-white">
            Start Date
          </label>
          <input
            type="date"
            id="startDate"
            name="startDate"
            value={formData.startDate?.split('T')[0]} // Convert ISO date to YYYY-MM-DD format
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="endDate" className="mb-3 block text-black dark:text-white">
            End Date
          </label>
          <input
            type="date"
            id="endDate"
            name="endDate"
            value={formData.endDate?.split('T')[0]} // Convert ISO date to YYYY-MM-DD format
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div className="flex items-center gap-2">
          <input
            type="checkbox"
            id="isActive"
            name="isActive"
            checked={formData.isActive}
            onChange={handleChange}
            className="rounded border-stroke text-primary focus:ring-0 dark:border-strokedark dark:bg-form-input dark:focus:ring-primary"
          />
          <label htmlFor="isActive" className="text-black dark:text-white">
            Is Active
          </label>
        </div>

        <div>
          <label htmlFor="minPurchaseAmount" className="mb-3 block text-black dark:text-white">
            Minimum Purchase Amount
          </label>
          <input
            type="number"
            id="minPurchaseAmount"
            name="minPurchaseAmount"
            value={formData.minPurchaseAmount || ''}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="maxDiscountAmount" className="mb-3 block text-black dark:text-white">
            Maximum Discount Amount
          </label>
          <input
            type="number"
            id="maxDiscountAmount"
            name="maxDiscountAmount"
            value={formData.maxDiscountAmount || ''}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div className="flex justify-end gap-4">
          <button
            type="button"
            onClick={handleBackClick}
            className="bg-secondary text-white py-2 px-4 rounded-lg hover:bg-opacity-90"
          >
            Cancel
          </button>
          <button
            type="submit"
            className="bg-primary text-white py-2 px-4 rounded-lg hover:bg-opacity-90"
          >
            {id ? 'Update Perk' : 'Create Perk'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default PerkForm;
