import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../../api';
import ConfirmationModal from '../../components/ConfirmationModal';

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
  images?: string;
  roleID?: number;
  addressID?: number;
  description?: string;
  createdBy?: number;
  createdAt?: string;
  updatedBy?: number;
  updatedAt?: string;
}

const UserList = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [showModal, setShowModal] = useState<boolean>(false);
  const [userToDelete, setUserToDelete] = useState<number | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await api.get('/users');
        setUsers(response.data);
      } catch (error) {
        console.error('Error fetching users:', error);
      }
    };

    fetchUsers();
  }, []);

  const handleEditClick = (userID: number) => {
    navigate(`/userform/${userID}`);
  };

  const handleAddNewClick = () => {
    navigate('/userform');
  };

  const handleDeleteClick = (userID: number) => {
    setUserToDelete(userID);
    setShowModal(true);
  };

  const handleConfirmDelete = async () => {
    if (userToDelete !== null) {
      try {
        await api.delete(`/users/${userToDelete}`);
        setUsers(users.filter((user) => user.userID !== userToDelete));
      } catch (error) {
        console.error('Error deleting user:', error);
      } finally {
        setShowModal(false);
        setUserToDelete(null);
      }
    }
  };

  return (
    <div className="rounded-sm border border-stroke bg-white px-5 pt-6 pb-2.5 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:pb-1">
      <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
        <h2 className="font-medium text-2xl text-black dark:text-white">User List</h2>
        <button
          onClick={handleAddNewClick}
          className="bg-primary text-white py-2 px-4 rounded-lg hover:bg-opacity-90"
        >
          Add New User
        </button>
      </div>
      <div className="max-w-full overflow-x-auto">
        <table className="w-full table-auto">
          <thead>
            <tr className="bg-gray-2 text-left dark:bg-meta-4">
              <th className="min-w-[220px] py-4 px-4 font-medium text-black dark:text-white xl:pl-11">Username</th>
              <th className="min-w-[220px] py-4 px-4 font-medium text-black dark:text-white">Email</th>
              <th className="py-4 px-4 font-medium text-black dark:text-white">Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user) => (
              <tr key={user.userID}>
                <td className="border-b border-[#eee] py-5 px-4 pl-9 dark:border-strokedark xl:pl-11">
                  <h5 className="font-medium text-black dark:text-white">{user.username}</h5>
                </td>
                <td className="border-b border-[#eee] py-5 px-4 dark:border-strokedark">
                  <h5 className="font-medium text-black dark:text-white">{user.userEmail}</h5>
                </td>
                <td className="border-b border-[#eee] py-5 px-4 dark:border-strokedark">
                  <div className="flex items-center space-x-3.5">
                    <button
                      className="hover:text-primary"
                      onClick={() => handleEditClick(user.userID)}
                    >
                      Edit
                    </button>
                    <button
                      className="hover:text-primary"
                      onClick={() => handleDeleteClick(user.userID)}
                    >
                      Delete
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <ConfirmationModal
        isOpen={showModal}
        onClose={() => setShowModal(false)}
        onConfirm={handleConfirmDelete}
        title="Confirm Deletion"
        message="Are you sure you want to delete this user?"
      />
    </div>
  );
};

export default UserList;
