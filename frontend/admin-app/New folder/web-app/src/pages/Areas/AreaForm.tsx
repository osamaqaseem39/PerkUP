import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import api from '../../api';

interface City {
  cityID: number;
  cityName: string;
}

interface Area {
  areaID: number;
  areaName: string;
  cityID: number;
  createdBy: number;
  createdAt: string;
  updatedBy: number;
  updatedAt: string;
}

const initialFormData: Area = {
  areaID: 0,
  areaName: '',
  cityID: 0,
  createdBy: 0,
  createdAt: new Date().toISOString(), // Ensure default date is valid
  updatedBy: 0,
  updatedAt: new Date().toISOString(), // Ensure default date is valid
};

const AreaForm = () => {
  const { id } = useParams();
  const [formData, setFormData] = useState<Area>(initialFormData);
  const [cities, setCities] = useState<City[]>([]);
  const [alert, setAlert] = useState<{ type: 'success' | 'error', message: string } | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchCities = async () => {
      try {
        const response = await api.get('/Cities'); // Replace with actual endpoint
        setCities(response.data);
      } catch (error) {
        console.error('Error fetching cities:', error);
      }
    };

    fetchCities();
  }, []);

  useEffect(() => {
    const fetchArea = async () => {
      if (id !== null && id !== undefined) {
        try {
          const response = await api.get(`/Areas/${id}`);
          setFormData(response.data);
        } catch (error) {
          console.error('Error fetching area data:', error);
        }
      }
    };

    fetchArea();
  }, [id]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: name === 'areaID' || name === 'cityID' ? parseInt(value, 10) : value,
    });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    try {
      if (id !== null && id !== undefined) {
        // Update existing area
        await api.put(`/Areas/${formData.areaID}`, formData);
        setAlert({ type: 'success', message: 'Area updated successfully!' });
      } else {
        // Create new area
        const response = await api.post('/Areas', formData);
        setFormData(response.data);
        setAlert({ type: 'success', message: 'Area created successfully!' });
      }

      // Optionally reset the form after successful submission
      setFormData(initialFormData);
      navigate('/area');
    } catch (error) {
      console.error('Error saving area:', error);
      setAlert({ type: 'error', message: 'Error saving area. Please try again later.' });
    }
  };

  const handleBackClick = () => {
    navigate('/area');
  };

  return (
    <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
      <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
        <h3 className="font-medium text-black dark:text-white">
          {id ? 'Update Area' : 'Create Area'}
        </h3>
        <button
          onClick={handleBackClick}
          className="bg-secondary text-white py-2 px-4 rounded-lg hover:bg-opaarea-90"
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
          <label htmlFor="areaName" className="mb-3 block text-black dark:text-white">
            Area Name
          </label>
          <input
            type="text"
            id="areaName"
            name="areaName"
            value={formData.areaName}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="cityID" className="mb-3 block text-black dark:text-white">
            City
          </label>
          <select
            id="cityID"
            name="cityID"
            value={formData.cityID}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          >
            <option value="" disabled>Select a city</option>
            {cities.map((city) => (
              <option key={city.cityID} value={city.cityID}>
                {city.cityName}
              </option>
            ))}
          </select>
        </div>

        <button
          type="submit"
          className="bg-primary text-white py-3 px-6 rounded-lg mt-6 mx-auto hover:bg-opaarea-90 focus:outline-none"
        >
          {id ? 'Update Area' : 'Create Area'}
        </button>
      </form>
    </div>
  );
};

export default AreaForm;
