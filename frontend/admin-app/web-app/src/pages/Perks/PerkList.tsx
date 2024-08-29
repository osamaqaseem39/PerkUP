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
                      {/* Edit Icon SVG */}
                    </button>
                    <button
                      className="hover:text-primary"
                      onClick={() => handleDeleteClick(perk.perkID)}
                    >
                      {/* Delete Icon SVG */}
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
