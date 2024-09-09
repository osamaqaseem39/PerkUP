import React, { useState, useEffect, ChangeEvent } from 'react'; 
import { useNavigate, useParams } from 'react-router-dom';
import api from '../../api';

interface User {
  userID: number;
  userType: string;
  username: string;
  displayName: string;
  firstName: string;
  lastName: string;
  userEmail: string;
  userContact: string;
  password: string;
  images: string;
  roleID: number | null;
  description: string;
  addressID: number | null;
  createdBy: number;
  createdAt: string;
  updatedBy: number;
  updatedAt: string;
}

const initialFormData: User = {
  userID: 0,
  userType: '',
  username: '',
  displayName: '',
  firstName: '',
  lastName: '',
  userEmail: '',
  userContact: '',
  password: '',
  images: '',
  roleID: null,
  description: '',
  addressID: null,
  createdBy: 0,
  createdAt: new Date().toISOString(), // Ensure default date is valid
  updatedBy: 0,
  updatedAt: new Date().toISOString(), // Ensure default date is valid
};

const UserForm = () => {
  const { id } = useParams();
  const [formData, setFormData] = useState<User>(initialFormData);
  const [alert, setAlert] = useState<{ type: 'success' | 'error'; message: string } | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchUser = async () => {
      if (id !== null && id !== undefined) {
        try {
          const response = await api.get(`/Users/${id}`);
          setFormData(response.data);
        } catch (error) {
          console.error('Error fetching user data:', error);
        }
      }
    };

    fetchUser();
  }, [id]);

  const handleChange = (
    e: ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>
  ) => {
    const { name, value } = e.target;
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };
  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    try {
      if (id !== null && id !== undefined) {
        // Update existing user
        await api.put(`/Users/${formData.userID}`, formData);
        setAlert({ type: 'success', message: 'User updated successfully!' });
      } else {
        // Create new user
        const response = await api.post('/Users', formData);
        setFormData(response.data);
        setAlert({ type: 'success', message: 'User created successfully!' });
      }

      // Optionally reset the form after successful submission
      setFormData(initialFormData);
      navigate('/users');
    } catch (error) {
      console.error('Error saving user:', error);
      setAlert({ type: 'error', message: 'Error saving user. Please try again later.' });
    }
  };

  const handleBackClick = () => {
    navigate('/user');
  };

  return (
    <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
      <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
        <h3 className="font-medium text-black dark:text-white">{id ? 'Update User' : 'Create User'}</h3>
        <button onClick={handleBackClick} className="bg-secondary text-white py-2 px-4 rounded-lg hover:bg-opacity-90">
          Back
        </button>
      </div>

      {alert && (
        <div
          className={`mt-4 mx-6.5 ${
            alert.type === 'success' ? 'text-green-700 bg-green-100' : 'text-red-700 bg-red-100'
          } py-2 px-4 rounded-lg`}
        >
          {alert.message}
        </div>
      )}

      <form onSubmit={handleSubmit} className="flex flex-col gap-5.5 p-6.5">
        <div>
          <label htmlFor="userType" className="mb-3 block text-black dark:text-white">
            User Type
          </label>
          <input
            type="text"
            id="userType"
            name="userType"
            value={formData.userType}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="username" className="mb-3 block text-black dark:text-white">
            Username
          </label>
          <input
            type="text"
            id="username"
            name="username"
            value={formData.username}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="displayName" className="mb-3 block text-black dark:text-white">
            Display Name
          </label>
          <input
            type="text"
            id="displayName"
            name="displayName"
            value={formData.displayName}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="firstName" className="mb-3 block text-black dark:text-white">
            First Name
          </label>
          <input
            type="text"
            id="firstName"
            name="firstName"
            value={formData.firstName}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="lastName" className="mb-3 block text-black dark:text-white">
            Last Name
          </label>
          <input
            type="text"
            id="lastName"
            name="lastName"
            value={formData.lastName}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="userEmail" className="mb-3 block text-black dark:text-white">
            User Email
          </label>
          <input
            type="email"
            id="userEmail"
            name="userEmail"
            value={formData.userEmail}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="userContact" className="mb-3 block text-black dark:text-white">
            User Contact
          </label>
          <input
            type="text"
            id="userContact"
            name="userContact"
            value={formData.userContact}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="password" className="mb-3 block text-black dark:text-white">
            Password
          </label>
          <input
            type="password"
            id="password"
            name="password"
            value={formData.password}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="images" className="mb-3 block text-black dark:text-white">
            Images (URL)
          </label>
          <input
            type="text"
            id="images"
            name="images"
            value={formData.images}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="roleID" className="mb-3 block text-black dark:text-white">
            Role ID
          </label>
          <input
            type="number"
            id="roleID"
            name="roleID"
            value={formData.roleID || ''}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
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
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="addressID" className="mb-3 block text-black dark:text-white">
            Address ID
          </label>
          <input
            type="number"
            id="addressID"
            name="addressID"
            value={formData.addressID || ''}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <button
          type="submit"
          className="mt-4 bg-primary text-white py-2 px-4 rounded-lg hover:bg-opacity-90"
        >
          {id ? 'Update User' : 'Create User'}
        </button>
      </form>
    </div>
  );
};

export default UserForm;
