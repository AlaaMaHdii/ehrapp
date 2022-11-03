var editor;

// Start tabel når hjemmesiden er klar.
$(document).ready( function () {
    editor = new $.fn.dataTable.Editor({
        ajax: 'data_test.json',
        table: "#consults",
        fields: [ {
            label: "Fornavn",
            name: "navn"
        }]
    });

    $('#consults').DataTable({
        ajax: 'data_test.json',
        responsive: true,
        language: {
            url: '//cdn.datatables.net/plug-ins/1.12.1/i18n/da.json'
        },
        select: {
            info: false
        },
        dom: "Bfrtip",
        buttons: [
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove", editor: editor }
        ]
    });
} );