var editor;

function capitalize(string) {
    // gør den første bogstav stor.
    return string.charAt(0).toUpperCase() + string.slice(1);
}

// Start tabel når hjemmesiden er klar.
$(document).ready( function () {
    editor = new $.fn.dataTable.Editor({
        idSrc:  'cpr',
        table: "#folkeregister",
        ajax: {
            create: {
                type: 'PUT',
                url:  '../rest/folkeregister'
            },
            edit: {
                type: 'POST',
                url:  '../rest/folkeregister?cpr={id}'
            },
            remove: {
                type: 'DELETE',
                url:  '../rest/folkeregister?cpr={id}'
            }
        },
        fields: [
            {
                label: "CPR-nummer",
                name: "cpr"
            },
            {
                label: "Navn",
                name: "name"
            }]
    });

    // Activate an inline edit on click of a table cell
    // tbody td.editable
    $('#folkeregister').on( 'click', 'tbody td:not(:first-child)', function (e) {
        editor.inline( this, {
            buttons: { label: '&gt;', fn: function () { this.submit(); } }
        } );
    } );

    editor.on('initEdit', function() {
        //editor.show(); //Shows all fields
        editor.hide('cpr');
    });
    editor.on('initCreate', function() {
        editor.show(); //Shows all fields
        //editor.hide('cpr');
    });

    editor.on('preOpen', function (e, mode, action) {
        if(action == 'remove') {
            let canContinue = true;
            var data = folkeregister_tabel.rows( { selected: true } ).data().toArray();
            for(row in data){
                if(data[row].antalKonsultationer != 0){
                    folkeregister_tabel.buttons.info(
                        'Advarsel',
                        'Kan ikke slette en borger hvor der er konsultationer registeret.',
                        3000
                    );
                    return false;
                }
            }
            return true;
        }
    });

    var folkeregister_tabel = $('#folkeregister').DataTable({
        ajax: '../rest/folkeregister',
        columns: [
            { data: 'cpr' },
            { data: 'name' },
            { data: 'antalKonsultationer' },
        ],
        responsive: true,
        language: {
            url: '//cdn.datatables.net/plug-ins/1.12.1/i18n/da.json'
        },
        select: {
            info: false
        },
        dom: "Bfrtip",
        buttons: [ {
            extend: 'pdf',
            customize: function (doc) {
                // fix fra https://stackoverflow.com/questions/35642802/datatables-export-pdf-with-100-width
                doc.content[1].table.widths =
                    Array(doc.content[1].table.body[0].length + 1).join('*').split('');
            }
        }, 'excel',
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove",   editor: editor }
        ]
    });



} );

