import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../../api';

interface Address {
  addressID: number;
  name: string;
  street: string;
  areaID: number;
  cityID: number;
  state: string;
  postalCode: string;
  countryID: number;
  latitude: number;
  longitude: number;
  createdBy: number;
  createdAt: string;
  updatedBy: number;
  updatedAt: string;
}

interface Country {
  countryID: number;
  countryName: string;
}

interface City {
  cityID: number;
  cityName: string;
}

interface Area {
  areaID: number;
  areaName: string;
}

const initialFormData: Address = {
  addressID: 0,
  name: '',
  street: '',
  areaID: 0,
  cityID: 0,
  state: '',
  postalCode: '',
  countryID: 0,
  latitude: 0,
  longitude: 0,
  createdBy: 0,
  createdAt: new Date().toISOString(),
  updatedBy: 0,
  updatedAt: new Date().toISOString(),
};

const AddressForm = ({ addressID }: { addressID?: number | null }) => {
  const [formData, setFormData] = useState<Address>(initialFormData);
  const [countries, setCountries] = useState<Country[]>([]);
  const [cities, setCities] = useState<City[]>([]);
  const [areas, setAreas] = useState<Area[]>([]);
  const [alert, setAlert] = useState<{ type: 'success' | 'error', message: string } | null>(null);
  const navigate = useNavigate();

  // Fetch address data if addressID is provided
  useEffect(() => {
    const fetchAddress = async () => {
      if (addressID !== null && addressID !== undefined) {
        try {
          const response = await api.get(`/Addresses/${addressID}`);
          setFormData(response.data);
        } catch (error) {
          console.error('Error fetching address data:', error);
        }
      }
    };

    fetchAddress();
  }, [addressID]);

  // Fetch countries
  useEffect(() => {
    const fetchCountries = async () => {
      try {
        const response = await api.get('/Countries');
        setCountries(response.data);
      } catch (error) {
        console.error('Error fetching countries:', error);
      }
    };

    fetchCountries();
  }, []);

  // Fetch cities based on selected country
  useEffect(() => {
    const fetchCities = async () => {
      if (formData.countryID) {
        try {
          const response = await api.get(`/Cities?countryID=${formData.countryID}`);
          setCities(response.data);
        } catch (error) {
          console.error('Error fetching cities:', error);
        }
      } else {
        setCities([]);
      }
    };

    fetchCities();
  }, [formData.countryID]);

  // Fetch areas based on selected city
  useEffect(() => {
    const fetchAreas = async () => {
      if (formData.cityID) {
        try {
          const response = await api.get(`/Areas?cityID=${formData.cityID}`);
          setAreas(response.data);
        } catch (error) {
          console.error('Error fetching areas:', error);
        }
      } else {
        setAreas([]);
      }
    };

    fetchAreas();
  }, [formData.cityID]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: name === 'latitude' || name === 'longitude' ? parseFloat(value) : value,
    });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    try {
      if (addressID !== null && addressID !== undefined) {
        // Update existing address
        await api.put(`/Addresses/${formData.addressID}`, formData);
        setAlert({ type: 'success', message: 'Address updated successfully!' });
      } else {
        // Create new address
        const response = await api.post('/Addresses', formData);
        setFormData(response.data);
        setAlert({ type: 'success', message: 'Address created successfully!' });
      }

      // Optionally reset the form after successful submission
      setFormData(initialFormData);
      navigate('/address');
    } catch (error) {
      console.error('Error saving address:', error);
      setAlert({ type: 'error', message: 'Error saving address. Please try again later.' });
    }
  };

  const handleBackClick = () => {
    navigate('/address');
  };

  return (
    <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
      <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
        <h3 className="font-medium text-black dark:text-white">
          {addressID ? 'Update Address' : 'Create Address'}
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
          <label htmlFor="name" className="mb-3 block text-black dark:text-white">
            Name
          </label>
          <input
            type="text"
            id="name"
            name="name"
            value={formData.name}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="street" className="mb-3 block text-black dark:text-white">
            Street
          </label>
          <input
            type="text"
            id="street"
            name="street"
            value={formData.street}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="countryID" className="mb-3 block text-black dark:text-white">
            Country
          </label>
          <select
            id="countryID"
            name="countryID"
            value={formData.countryID}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          >
            <option value="">Select a country</option>
            {countries.map((country) => (
              <option key={country.countryID} value={country.countryID}>
                {country.countryName}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label htmlFor="state" className="mb-3 block text-black dark:text-white">
            State
          </label>
          <select
            id="state"
            name="state"
            value={formData.state}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          >
            <option value="">Select a state</option>
            <option value="Punjab">Punjab</option>
            <option value="Sindh">Sindh</option>
            <option value="Balochistan">Balochistan</option>
            <option value="KPK">KPK</option>
          </select>
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
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          >
            <option value="">Select a city</option>
            {cities.map((city) => (
              <option key={city.cityID} value={city.cityID}>
                {city.cityName}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label htmlFor="areaID" className="mb-3 block text-black dark:text-white">
            Area
          </label>
          <select
            id="areaID"
            name="areaID"
            value={formData.areaID}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          >
            <option value="">Select an area</option>
            {areas.map((area) => (
              <option key={area.areaID} value={area.areaID}>
                {area.areaName}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label htmlFor="postalCode" className="mb-3 block text-black dark:text-white">
            Postal Code
          </label>
          <input
            type="text"
            id="postalCode"
            name="postalCode"
            value={formData.postalCode}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="latitude" className="mb-3 block text-black dark:text-white">
            Latitude
          </label>
          <input
            type="number"
            step="0.000001"
            id="latitude"
            name="latitude"
            value={formData.latitude}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="longitude" className="mb-3 block text-black dark:text-white">
            Longitude
          </label>
          <input
            type="number"
            step="0.000001"
            id="longitude"
            name="longitude"
            value={formData.longitude}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div className="flex justify-between">
          <button
            type="submit"
            className="w-full rounded-lg border border-primary bg-primary py-3 px-5 text-base font-medium text-white transition hover:bg-opacity-90"
          >
            {addressID ? 'Update Address' : 'Create Address'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default AddressForm;
