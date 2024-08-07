import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../../api';


interface Area {
  areaID: number;
  areaName: string;
}

const initialFormData: Area = {
  areaID: 0,
  areaName: '',
};

const AreaForm = ({ areaID }: { areaID?: number | null }) => {
  const [formData, setFormData] = useState<Area>(initialFormData);
  const [alert, setAlert] = useState<{ type: 'success' | 'error', message: string } | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
 
    const fetchArea = async () => {
      if (areaID !== null && areaID !== undefined) {
        try {
          const response = await api.get(`/Areas/${areaID}`);
          setFormData(response.data);
        } catch (error) {
          console.error('Error fetching area data:', error);
        }
      }
    };

    fetchArea();
  }, [areaID]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: name === 'areaID' ? parseInt(value, 10) : value,
    });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    try {
      if (areaID !== null && areaID !== undefined) {
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
          {areaID ? 'Update Area' : 'Create Area'}
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

       
        <button
          type="submit"
          className="bg-primary text-white py-3 px-6 rounded-lg mt-6 mx-auto hover:bg-opaarea-90 focus:outline-none"
        >
          {areaID ? 'Update Area' : 'Create Area'}
        </button>
      </form>
    </div>
  );
};

export default AreaForm;
