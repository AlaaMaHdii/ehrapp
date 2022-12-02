var editor;

function capitalize(string) {
    // gør den første bogstav stor.
    return string.charAt(0).toUpperCase() + string.slice(1);
}

//  https://datatables.net/plug-ins/dataRender/datetime
$.fn.dataTable.render.moment = function ( from, to, locale ) {
    // Argument shifting
    if ( arguments.length === 1 ) {
        locale = 'da';
        to = from;
        from = 'YYYY-MM-DD hh:mm:ss.SSS';
    }
    else if ( arguments.length === 2 ) {
        locale = 'da';
    }

    return function ( d, type, row ) {
        if (! d) {
            return type === 'sort' || type === 'type' ? 0 : d;
        }

        var m = window.moment( d, from, locale, true );

        // Order and type get a number value from Moment, everything else
        // sees the rendered value
        return m.format( type === 'sort' || type === 'type' ? 'x' : to );
    };
};

// Start tabel når hjemmesiden er klar.
$(document).ready( function () {
    editor = new $.fn.dataTable.Editor({
        idSrc:  'id',
        table: "#personale",
        ajax: {
            create: {
                type: 'PUT',
                url:  '../rest/sundhedspersonale'
            },
            edit: {
                type: 'POST',
                url:  '../rest/sundhedspersonale?id={id}'
            },
            remove: {
                type: 'DELETE',
                url:  '../rest/sundhedspersonale?id={id}'
            }
        },
        fields: [
            {
                label: "Navn",
                name: "name"
            },
            {
                label: "Stilling",
                name: "roles", type: 'checkbox',
                separator:  ", ",
                options: [
                    { label: "Administrator", value: "Admin" },
                    { label: "Læge", value: "Læge" },
                    { label: "API-adgang", value: "API" }
                ]
            },
            {
                label: "E-mail",
                name: "email"
            },
            {
                label: "Telefonnummer",
                name: "phoneNumber"
            },
            {
                label: "Adgang",
                name:  "isDisabled",
                type:  "radio",
                options: [
                    { label: "Tilladt", value: false },
                    { label: "Blokeret",  value: true }
                ]
            },
            {
                label: "Adgangskode",
                name: "password"
            }
            ]
    });


    editor.on('preOpen', function (e, mode, action) {
        if(action == 'remove') {
            let canContinue = true;
            var data = personaleTabel.rows( { selected: true } ).data().toArray();
            for(row in data){
                if(data[row].antalKonsultationer != 0){
                    personaleTabel.buttons.info(
                        'Advarsel',
                        'Kan ikke slette en medarbejder hvor der er konsultationer registeret. Blokere adgangen i stedet.',
                        3000
                    );
                    return false;
                }
            }
            return true;
        }
    });

    var personaleTabel = $('#personale').DataTable({
        ajax: '../rest/sundhedspersonale',
        columns: [
            { data: 'name' },
            { data: 'roles'},
            { data: 'email' },
            { data: 'phoneNumber'},
            { data: 'antalKonsultationer'},
            { data: 'password'},
            { data: 'isDisabled', render: function ( data, type, row, meta ) {
                    if(type === 'display'){
                        if(data){
                            return "Blokeret"
                        }
                        return "Tilladt"
                    }
                    return data;
                } }
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
            { extend: "remove", editor: editor }
        ]
    });
} );

