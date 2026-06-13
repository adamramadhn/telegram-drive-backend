// Update telegram-drive.html untuk connect ke backend

// Tambahkan di bagian atas script (line ~359):
const BACKEND_URL = localStorage.getItem('telegramDriveBackendUrl') || '';

// Ganti loadFiles() dengan versi backend:
async function loadFiles() {
    const loadingDiv = document.getElementById('loading');
    const fileGrid = document.getElementById('file-grid');

    loadingDiv.style.display = 'block';
    fileGrid.innerHTML = '';

    try {
        // Cek apakah backend URL tersedia
        if (!BACKEND_URL) {
            showStatus('❌ Backend URL belum diset! Masukkan di settings.', 'error');
            return;
        }

        const response = await fetch(`${BACKEND_URL}/api/files?refresh=true`);
        const data = await response.json();

        if (!response.ok) {
            showStatus('❌ Gagal memuat file: ' + (data.detail || 'Unknown error'), 'error');
            return;
        }

        const files = data.files || [];
        allFiles = files;

        displayFiles(files);
        updateStats(files);
        showStatus(`✅ ${files.length} file dimuat`, 'success', 3000);

    } catch (error) {
        showStatus('❌ Gagal memuat file: ' + error.message, 'error', 5000);
    } finally {
        loadingDiv.style.display = 'none';
    }
}

// Ganti uploadFiles() dengan versi backend:
async function uploadFiles(files) {
    const statusDiv = document.getElementById('upload-status');

    if (!BACKEND_URL) {
        showStatus('❌ Backend URL belum diset!', 'error');
        return;
    }

    for (const file of files) {
        if (file.size > 2 * 1024 * 1024 * 1024) {  // 2GB limit untuk Client API
            showStatus(`❌ ${file.name} terlalu besar (max 2GB)`, 'error');
            continue;
        }

        statusDiv.innerHTML = `
            <div class="status info">
                <div>📤 Uploading: ${file.name}</div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 50%"></div>
                </div>
            </div>
        `;

        const formData = new FormData();
        formData.append('file', file);
        formData.append('caption', file.name);

        try {
            const response = await fetch(`${BACKEND_URL}/api/upload`, {
                method: 'POST',
                body: formData
            });

            const data = await response.json();

            if (response.ok) {
                statusDiv.innerHTML = `
                    <div class="status success">
                        ✅ ${file.name} berhasil diupload!
                    </div>
                `;
            } else {
                showStatus(`❌ Gagal upload ${file.name}: ${data.detail}`, 'error');
            }

        } catch (error) {
            showStatus(`❌ Error upload ${file.name}: ${error.message}`, 'error');
        }

        await new Promise(resolve => setTimeout(resolve, 500));
    }

    setTimeout(() => {
        statusDiv.innerHTML = '';
        loadFiles();
    }, 1500);
}

// Ganti downloadFile() dengan versi backend:
async function downloadFile(fileId, fileName) {
    showStatus('🔄 Menyiapkan download...', 'info');

    try {
        if (!BACKEND_URL) {
            showStatus('❌ Backend URL belum diset!', 'error');
            return;
        }

        const fileUrl = `${BACKEND_URL}/api/download/${fileId}`;

        const link = document.createElement('a');
        link.href = fileUrl;
        link.download = fileName;
        link.target = '_blank';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        showStatus('✅ File dimuat untuk download', 'success', 3000);

    } catch (error) {
        showStatus('❌ Gagal download: ' + error.message, 'error', 5000);
    }
}

// Ganti deleteFile() dengan versi backend:
async function deleteFile(messageId) {
    if (!confirm('Apakah kamu yakin ingin menghapus file ini?')) {
        return;
    }

    showStatus('🔄 Menghapus file...', 'info');

    try {
        if (!BACKEND_URL) {
            showStatus('❌ Backend URL belum diset!', 'error');
            return;
        }

        const response = await fetch(`${BACKEND_URL}/api/files/${messageId}`, {
            method: 'DELETE'
        });

        const data = await response.json();

        if (response.ok) {
            showStatus('✅ File berhasil dihapus!', 'success', 3000);
            loadFiles();
        } else {
            showStatus(`❌ Gagal menghapus: ${data.detail}`, 'error');
        }

    } catch (error) {
        showStatus('❌ Error: ' + error.message, 'error', 5000);
    }
}

// Update updateStats() untuk panggil backend:
async function updateStats(files) {
    try {
        if (!BACKEND_URL) return;

        const response = await fetch(`${BACKEND_URL}/api/stats`);
        const data = await response.json();

        if (response.ok) {
            document.getElementById('total-files').textContent = data.total_files;
            document.getElementById('total-size').textContent = formatSize(data.total_size);
            document.getElementById('image-count').textContent = data.image_count;
            document.getElementById('other-count').textContent = data.other_count;
        }
    } catch (error) {
        console.error('Gagal update stats:', error);
    }
}

// Tambahkan fungsi setup backend URL:
function setupBackendUrl() {
    const currentUrl = localStorage.getItem('telegramDriveBackendUrl') || '';

    const newUrl = prompt(
        'Masukkan Backend URL Railway:\n\n' +
        'Contoh: https://telegram-drive-backend-xxxx.up.railway.app\n\n' +
        'URL saat ini: ' + (currentUrl || '(belum diset)'),
        currentUrl
    );

    if (newUrl && newUrl.trim() !== '') {
        localStorage.setItem('telegramDriveBackendUrl', newUrl.trim());
        showStatus('✅ Backend URL tersimpan!', 'success', 3000);
        return newUrl.trim();
    }

    return currentUrl;
}

// Hapus atau comment debugUpdates() karena tidak perlu lagi dengan backend
// (Optional, bisa disimpan untuk troubleshooting)