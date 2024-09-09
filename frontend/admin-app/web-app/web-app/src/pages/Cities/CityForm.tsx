import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import api from '../../api';



interface City {
  cityID: number;
  cityName: string;
}

const initialFormData: City = {
  cityID: 0,
  cityName: '',
};

const CityForm = () => {
  const { id } = useParams();

  const [formData, setFormData] = useState<City>(initialFormData);
  const [alert, setAlert] = useState<{ type: 'success' | 'error', message: string } | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
 
    const fetchCity = async () => {
      if (id !== null && id !== undefined) {
        try {
          const response = await api.get(`/Cities/${id}`);
          setFormData(response.data);
        } catch (error) {
          console.error('Error fetching city data:', error);
        }
      }
    };

    fetchCity();
  }, [id]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: name === 'cityID' ? parseInt(value, 10) : value,
    });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    try {
      if (id !== null && id !== undefined) {
        // Update existing city
        await api.put(`/Cities/${formData.cityID}`, formData);
        setAlert({ type: 'success', message: 'City updated successfully!' });
      } else {
        // Create new city
        const response = await api.post('/Cities', formData);
        setFormData(response.data);
        setAlert({ type: 'success', message: 'City created successfully!' });
      }

      // Optionally reset the form after successful submission
      setFormData(initialFormData);
      navigate('/city');
    } catch (error) {
      console.error('Error saving city:', error);
      setAlert({ type: 'error', message: 'Error saving city. Please try again later.' });
    }
  };

  const handleBackClick = () => {
    navigate('/city');
  };

  return (
    <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
      <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
        <h3 className="font-medium text-black dark:text-white">
          {id ? 'Update City' : 'Create City'}
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
          <label htmlFor="cityName" className="mb-3 block text-black dark:text-white">
            City Name
          </label>
          <input
            type="text"
            id="cityName"
            name="cityName"
            value={formData.cityName}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

       
        <button
          type="submit"
          className="bg-primary text-white py-3 px-6 rounded-lg mt-6 mx-auto hover:bg-opacity-90 focus:outline-none"
        >
          {id ? 'Update City' : 'Create City'}
        </button>
      </form>
    </div>
  );
};

export default CityForm;
