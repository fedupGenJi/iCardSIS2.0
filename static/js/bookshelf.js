function searchBooks() {
    let input = document.getElementById("search-input").value.toLowerCase();
    let table = document.getElementById("shelf-table");
    let rows = table.getElementsByTagName("tr");

    for (let i = 1; i < rows.length; i++) { 
        let bookNameCell = rows[i].getElementsByTagName("td")[1]; 
        if (bookNameCell) {
            let bookName = bookNameCell.textContent || bookNameCell.innerText;
            if (bookName.toLowerCase().includes(input)) {
                rows[i].style.display = "";
            } else {
                rows[i].style.display = "none";
            }
        }
    }
}
