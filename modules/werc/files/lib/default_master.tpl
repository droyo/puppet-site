<div id="main-copy">

% run_handlers $handlers_body_head

% run_handler $handler_body_main

% run_handlers $handlers_body_foot

</div>

<div id="footer">
% cat `{ get_lib_file footer.inc }
</div>
