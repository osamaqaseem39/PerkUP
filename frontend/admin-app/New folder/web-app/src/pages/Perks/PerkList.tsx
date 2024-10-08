import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../../api';
import ConfirmationModal from '../../components/ConfirmationModal';

interface Perk {
  perkID: number;
  perkName: string;
}

const PerkList = () => {
  const [perks, setPerks] = useState<Perk[]>([]);
  const [showModal, setShowModal] = useState<boolean>(false);
  const [perkToDelete, setPerkToDelete] = useState<number | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchPerks = async () => {
      try {
        const response = await api.get('/Perks');
        setPerks(response.data);
      } catch (error) {
        console.error('Error fetching perks:', error);
      }
    };

    fetchPerks();
  }, []);

  const handleEditClick = (perkID: number) => {
    navigate(`/perkform/${perkID}`);
  };

  const handleAddNewClick = () => {
    navigate('/perkform');
  };

  const handleDeleteClick = (perkID: number) => {
    setPerkToDelete(perkID);
    setShowModal(true);
  };

  const handleConfirmDelete = async () => {
    if (perkToDelete !== null) {
      try {
        await api.delete(`/Perks/${perkToDelete}`);
        setPerks(perks.filter((perk) => perk.perkID !== perkToDelete));
      } catch (error) {
        console.error('Error deleting perk:', error);
      } finally {
        setShowModal(false);
        setPerkToDelete(null);
      }
    }
  };

  return (
    <div className="rounded-sm border border-stroke bg-white px-5 pt-6 pb-2.5 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:pb-1">
      <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
        <h2 className="font-medium text-2xl text-black dark:text-white">Perks</h2>
        <button
          onClick={handleAddNewClick}
          className="bg-primary text-white py-2 px-4 rounded-lg hover:bg-opacity-90"
        >
          Add New Perk
        </button>
      </div>
      <div className="max-w-full overflow-x-auto">
        <table className="w-full table-auto">
          <thead>
            <tr className="bg-gray-2 text-left dark:bg-meta-4">
              <th className="min-w-[220px] py-4 px-4 font-medium text-black dark:text-white xl:pl-11">Perk Name</th>
              <th className="py-4 px-4 font-medium text-black dark:text-white">Actions</th>
            </tr>
          </thead>
          <tbody>
            {perks.map((perk) => (
              <tr key={perk.perkID}>
                <td className="border-b border-[#eee] py-5 px-4 pl-9 dark:border-strokedark xl:pl-11">
                  <h5 className="font-medium text-black dark:text-white">{perk.perkName}</h5>
                </td>
                <td className="border-b border-[#eee] py-5 px-4 dark:border-strokedark">
                  <div className="flex items-center space-x-3.5">
                  <button
                      className="hover:text-primary"
                      onClick={() => handleEditClick(perk.perkID)}
                    >
                      <svg
                        className="fill-current"
                        width="18"
                        height="18"
                        viewBox="0 0 18 18"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                      >
                        <path
                          d="M8.99981 14.8219C3.43106 14.8219 0.674805 9.50624 0.562305 9.28124C0.47793 9.11249 0.47793 8.88749 0.562305 8.71874C0.674805 8.49374 3.43106 3.20624 8.99981 3.20624C14.5686 3.20624 17.3248 8.49374 17.4373 8.71874C17.5217 8.88749 17.5217 9.11249 17.4373 9.28124C17.3248 9.50624 14.5686 14.8219 8.99981 14.8219ZM1.85605 8.99999C2.4748 10.0406 4.89356 13.5562 8.99981 13.5562C13.1061 13.5562 15.5248 10.0406 16.1436 8.99999C15.5248 7.95936 13.1061 4.44374 8.99981 4.44374C4.89356 4.44374 2.4748 7.95936 1.85605 8.99999Z"
                        />
                        <path
                          d="M9 11.3906C7.67812 11.3906 6.60938 10.3219 6.60938 9C6.60938 7.67813 7.67812 6.60938 9 6.60938C10.3219 6.60938 11.3906 7.67813 11.3906 9C11.3906 10.3219 10.3219 11.3906 9 11.3906ZM9 7.875C8.38125 7.875 7.875 8.38125 7.875 9C7.875 9.61875 8.38125 10.125 9 10.125C9.61875 10.125 10.125 9.61875 10.125 9C10.125 8.38125 9.61875 7.875 9 7.875Z"
                        />
                      </svg>
                    </button>
                    <button
                      className="hover:text-primary"
                      onClick={() => handleDeleteClick(perk.perkID)}
                    >
                      <svg
                        className="fill-current"
                        width="18"
                        height="18"
                        viewBox="0 0 18 18"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                      >
                        <path
                          d="M14.25 4.5H3.75C3.33579 4.5 3 4.83579 3 5.25V13.5C3 14.7426 4.00736 15.75 5.25 15.75H12.75C13.9926 15.75 15 14.7426 15 13.5V5.25C15 4.83579 14.6642 4.5 14.25 4.5ZM13.5 13.5C13.5 14.1904 12.9404 14.75 12.25 14.75H5.75C5.05964 14.75 4.5 14.1904 4.5 13.5V5.5H13.5V13.5ZM12.375 3H5.625L5.5 2.25H12.5L12.375 3ZM8.25 6C7.83579 6 7.5 6.33579 7.5 6.75V12C7.5 12.4142 7.83579 12.75 8.25 12.75C8.66421 12.75 9 12.4142 9 12V6.75C9 6.33579 8.66421 6 8.25 6ZM10.5 6.75C10.5 6.33579 10.8358 6 11.25 6C11.6642 6 12 6.33579 12 6.75V12C12 12.4142 11.6642 12.75 11.25 12.75C10.8358 12.75 10.5 12.4142 10.5 12V6.75Z"
                        />
                      </svg>
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
        message="Are you sure you want to delete this perk?"
      />
    </div>
  );
};

export default PerkList;
